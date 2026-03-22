require('dotenv').config();
const express = require('express');
const cors = require('cors');
const { fetchVehicleStatus, getCache } = require('./arventoService');

const app = express();
const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

// Mock Worker's Stop (e.g., Izmit Center)
const WORKER_STOP = { lat: 40.7654, lon: 29.9408 };

// Haversine distance formula in kilometers
function getDistance(lat1, lon1, lat2, lon2) {
  const R = 6371; // Radius of the earth in km
  const dLat = deg2rad(lat2 - lat1);
  const dLon = deg2rad(lon2 - lon1);
  const a =
    Math.sin(dLat / 2) * Math.sin(dLat / 2) +
    Math.cos(deg2rad(lat1)) * Math.cos(deg2rad(lat2)) *
    Math.sin(dLon / 2) * Math.sin(dLon / 2);
  const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1 - a));
  const d = R * c; // Distance in km
  return d;
}

function deg2rad(deg) {
  return deg * (Math.PI / 180);
}

// Main API endpoint to get vehicles
app.get('/api/vehicles', (req, res) => {
  const factoryCode = req.query.factoryCode;
  let data = getCache();

  // Optionally filter by factory code if provided in query
  if (factoryCode && Array.isArray(data)) {
    data = data.filter(v => v.FactoryCode === factoryCode);
  }

  // Add Distance and ETA to each vehicle
  if (Array.isArray(data)) {
    data = data.map(v => {
      const distance = getDistance(v.Latitude, v.Longitude, WORKER_STOP.lat, WORKER_STOP.lon);
      const avgSpeed = v.Speed > 10 ? v.Speed : 40; // use vehicle speed or fallback 40km/h
      const durationMin = Math.round((distance / avgSpeed) * 60 + 2); // add 2 mins buffer

      return {
        ...v,
        DistanceKm: parseFloat(distance.toFixed(2)),
        EtaMin: durationMin
      };
    });
  }

  res.json({
    success: true,
    count: Array.isArray(data) ? data.length : 0,
    timestamp: new Date().toISOString(),
    data: data
  });
});

// Default route
app.get('/', (req, res) => {
  res.send('Servis Yolunda API is running!');
});

// Start the polling interval
const POLLING_INTERVAL_MS = 35 * 1000; // 35 seconds

async function startServer() {
  // Initial fetch
  await fetchVehicleStatus();

  // Set interval for continuous polling
  setInterval(fetchVehicleStatus, POLLING_INTERVAL_MS);

  app.listen(PORT, () => {
    console.log(`Server is running on http://localhost:${PORT}`);
    console.log(`Polling Arvento API every ${POLLING_INTERVAL_MS / 1000} seconds...`);
  });
}

startServer();

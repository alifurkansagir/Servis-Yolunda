// Kocaeli coordinates roughly center around 40.7654, 29.9408
const MOCK_FACTORIES = ['FAC100', 'FAC200', 'FAC300'];

let mockVehicles = [];

function initMockData() {
  for (let i = 0; i < 15; i++) {
    mockVehicles.push({
      NodeID: `VEH-${1000 + i}`,
      Plate: `41 ${String.fromCharCode(65 + (i % 26))}${String.fromCharCode(65 + ((i+1) % 26))} ${100 + i}`,
      Latitude: 40.7654 + (Math.random() - 0.5) * 0.1,
      Longitude: 29.9408 + (Math.random() - 0.5) * 0.1,
      Speed: Math.floor(Math.random() * 80),
      Ignition: true,
      FactoryCode: MOCK_FACTORIES[i % MOCK_FACTORIES.length] // mock custom attribute
    });
  }
}

function updateMockData() {
  // Simulate movement
  mockVehicles = mockVehicles.map(v => {
    return {
      ...v,
      Latitude: v.Latitude + (Math.random() - 0.5) * 0.002, // move slightly
      Longitude: v.Longitude + (Math.random() - 0.5) * 0.002,
      Speed: Math.floor(Math.random() * 80)
    }
  });
  return mockVehicles;
}

function generateMockData() {
  if (mockVehicles.length === 0) {
    initMockData();
  }
  return updateMockData();
}

module.exports = {
  generateMockData
};

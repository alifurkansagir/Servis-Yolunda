const axios = require('axios');
const { XMLParser } = require('fast-xml-parser');
const mockData = require('./mockData');

const ARVENTO_URL = 'http://ws.arvento.com/v1/report.asmx';

let vehicleCache = [];

const parser = new XMLParser({
  ignoreAttributes: false,
  attributeNamePrefix : "@_"
});

async function fetchVehicleStatus() {
  const { ARVENTO_USERNAME, ARVENTO_PIN1, ARVENTO_PIN2, USE_MOCK_DATA } = process.env;

  if (USE_MOCK_DATA === 'true') {
    console.log('[ArventoService] Using mock data...');
    vehicleCache = mockData.generateMockData();
    return;
  }

  if (!ARVENTO_USERNAME || !ARVENTO_PIN1 || !ARVENTO_PIN2) {
    console.error('[ArventoService] Missing Arvento credentials!');
    return;
  }

  const xmlRequest = `<?xml version="1.0" encoding="utf-8"?>
<soap:Envelope xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xmlns:xsd="http://www.w3.org/2001/XMLSchema" xmlns:soap="http://schemas.xmlsoap.org/soap/envelope/">
  <soap:Body>
    <GetVehicleStatus xmlns="http://ws.arvento.com/v1/report.asmx">
      <Username>${ARVENTO_USERNAME}</Username>
      <PIN1>${ARVENTO_PIN1}</PIN1>
      <PIN2>${ARVENTO_PIN2}</PIN2>
    </GetVehicleStatus>
  </soap:Body>
</soap:Envelope>`;

  try {
    const response = await axios.post(ARVENTO_URL, xmlRequest, {
      headers: {
        'Content-Type': 'text/xml; charset=utf-8',
        'SOAPAction': 'http://ws.arvento.com/v1/report.asmx/GetVehicleStatus'
      }
    });

    const jsonObj = parser.parse(response.data);
    
    const resultNode = jsonObj?.['soap:Envelope']?.['soap:Body']?.['GetVehicleStatusResponse']?.['GetVehicleStatusResult'];
    
    if (resultNode) {
      console.log('[ArventoService] Successfully fetched data from Arvento.');
      vehicleCache = resultNode; 
    } else {
      console.error('[ArventoService] Unexpected XML structure:', JSON.stringify(jsonObj).substring(0, 200));
    }
  } catch (error) {
    console.error('[ArventoService] Error fetching data:', error.message);
  }
}

function getCache() {
  return vehicleCache;
}

module.exports = {
  fetchVehicleStatus,
  getCache
};

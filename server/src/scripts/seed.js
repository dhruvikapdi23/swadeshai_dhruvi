require('dotenv').config();
const { initFirebase } = require('../config/firebase');
const { seedVenuesIfEmpty } = require('../services/seedService');

async function seed() {
  initFirebase();
  await seedVenuesIfEmpty();
}

seed().catch((error) => {
  console.error('Seed failed:', error.message);
  process.exit(1);
});

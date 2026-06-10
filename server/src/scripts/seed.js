require('dotenv').config();
const { initFirebase, getDb } = require('../config/firebase');
const { VENUES } = require('../data/venues.seed');

async function seed() {
  initFirebase();
  const db = getDb();
  const batch = db.batch();

  for (const venue of VENUES) {
    const ref = db.collection('venues').doc(venue.id);
    batch.set(ref, venue, { merge: true });
  }

  await batch.commit();
  console.log(`Seeded ${VENUES.length} venues into Firestore.`);
}

seed().catch((error) => {
  console.error('Seed failed:', error.message);
  process.exit(1);
});

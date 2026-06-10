/** 5 seeded venues — written to Firestore on `npm run seed`. */
const VENUES = [
  {
    id: 'venue-1',
    name: 'Smash Arena',
    type: 'badminton',
    location: 'Koramangala, Bengaluru',
    description: '4 premium wooden courts with floodlights.',
    pricePerHour: 450,
  },
  {
    id: 'venue-2',
    name: 'Green Turf Central',
    type: 'turf',
    location: 'Andheri West, Mumbai',
    description: 'FIFA-standard 5-a-side turf with locker rooms.',
    pricePerHour: 1200,
  },
  {
    id: 'venue-3',
    name: 'Rally Point',
    type: 'badminton',
    location: 'Hitech City, Hyderabad',
    description: 'Air-conditioned courts, equipment rental on site.',
    pricePerHour: 500,
  },
  {
    id: 'venue-4',
    name: 'Urban Kickbox Turf',
    type: 'turf',
    location: 'Saket, New Delhi',
    description: 'Synthetic turf with evening floodlights.',
    pricePerHour: 900,
  },
  {
    id: 'venue-5',
    name: 'PlayHub Multi-Sport',
    type: 'multi_sport',
    location: 'Indiranagar, Bengaluru',
    description: 'Badminton, futsal, and cricket nets under one roof.',
    pricePerHour: 650,
  },
];

module.exports = { VENUES };

const express = require('express');
const venueService = require('../services/venueService');

const router = express.Router();

/** GET /venues */
router.get('/', async (_req, res, next) => {
  try {
    const venues = await venueService.listVenues();
    res.json(venues);
  } catch (error) {
    next(error);
  }
});

/** GET /venues/:id */
router.get('/:id', async (req, res, next) => {
  try {
    const venue = await venueService.getVenueById(req.params.id);
    if (!venue) {
      return res.status(404).json({ error: 'Venue not found' });
    }
    return res.json(venue);
  } catch (error) {
    return next(error);
  }
});

/** GET /venues/:id/slots?date=YYYY-MM-DD */
router.get('/:id/slots', async (req, res, next) => {
  try {
    const { date } = req.query;
    if (!date) {
      return res.status(400).json({ error: 'date query parameter is required' });
    }

    const slots = await venueService.getSlotsForDate(req.params.id, date);
    return res.json(slots);
  } catch (error) {
    return next(error);
  }
});

module.exports = router;

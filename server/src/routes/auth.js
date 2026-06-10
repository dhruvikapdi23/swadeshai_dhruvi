const express = require('express');
const userService = require('../services/userService');

const router = express.Router();

/** POST /auth/register */
router.post('/register', async (req, res, next) => {
  try {
    const { name, email, password, deviceToken } = req.body ?? {};
    const user = await userService.registerUser({
      name,
      email,
      password,
      deviceToken,
    });
    return res.status(201).json(user);
  } catch (error) {
    return next(error);
  }
});

/** POST /auth/login */
router.post('/login', async (req, res, next) => {
  try {
    const { email, password, deviceToken } = req.body ?? {};
    const user = await userService.loginUser({ email, password, deviceToken });
    return res.json(user);
  } catch (error) {
    return next(error);
  }
});

module.exports = router;

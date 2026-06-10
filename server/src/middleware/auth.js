const userService = require('../services/userService');

const USER_HEADER = 'x-user-id';

/** Validates X-User-Id against Firestore users collection. */
async function requireUser(req, res, next) {
  const userId = req.header(USER_HEADER);

  if (!userId) {
    return res.status(401).json({ error: 'Missing X-User-Id header' });
  }

  try {
    const user = await userService.getUserById(userId);
    if (!user) {
      return res.status(401).json({ error: 'Invalid user id' });
    }

    req.userId = userId;
    req.user = user;
    return next();
  } catch (error) {
    return next(error);
  }
}

module.exports = { requireUser, USER_HEADER };

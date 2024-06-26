const jwt = require('jsonwebtoken')
const User = require('../models/user.model')

const protect = async (req, res, next) => {
  const bearer = req.header('Authorization')
  if (!bearer || !bearer.startsWith('Bearer '))
    return res.status(401).json({ message: 'Unauthorized' })
  const token = bearer.substring(bearer.indexOf(' ') + 1)

  try {
    const decoded = jwt.verify(
      token.substring(token.indexOf(' ') + 1),
      process.env.JWT_SECRET
    )
    if (!(await User.exists({ _id: decoded.id, sessions: token })))
      return res.status(401).json({ message: 'Unauthorized' })

    req.user = decoded.id
    next()
  } catch (error) {
    res.status(401).json(error)
    console.error('Error authenticating user: ', error)
  }
}

module.exports = protect

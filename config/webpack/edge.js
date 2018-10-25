process.env.NODE_ENV = process.env.NODE_ENV || 'edge'

const environment = require('./environment')

module.exports = environment.toWebpackConfig()

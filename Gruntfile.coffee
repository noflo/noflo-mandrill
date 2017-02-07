module.exports = ->
  # Project configuration
  @initConfig
    pkg: @file.readJSON 'package.json'

    # Updating the package manifest files
    noflo_manifest:
      update:
        files:
          'package.json': ['graphs/*', 'components/*']

    # BDD tests on Node.js
    mochaTest:
      nodejs:
        src: ['spec/*.coffee']
        options:
          reporter: 'spec'

    # Coding standards
    coffeelint:
      components: ['components/*.coffee']

  # Grunt plugins used for testing
  @loadNpmTasks 'grunt-mocha-test'
  @loadNpmTasks 'grunt-coffeelint'
  @loadNpmTasks 'grunt-noflo-manifest'

  @registerTask 'test', ['coffeelint', 'noflo_manifest', 'mochaTest']
  @registerTask 'default', ['test']

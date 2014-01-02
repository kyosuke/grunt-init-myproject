/*
 * grunt-init-myproject
 * https://github.com/kyosuke/grunt-init-myproject
 *
 * Copyright (c) 2014 Kyosuke Nakamura
 * Licensed under the MIT license.
 */

'use strict';

// Basic template description.
exports.description = 'Create a Gruntfile.coffee.';

// Template-specific notes to be displayed before question prompts.
exports.notes = 'exports.notes';

// Template-specific notes to be displayed after question prompts.
exports.after = 'You should now install project dependencies with _npm ' +
  'install_. After that, you may execute project tasks with _grunt_.';

// Any existing file or directory matching this wildcard will cause a warning.
exports.warnOn = '*';

// The actual init template.
exports.template = function(grunt, init, done) {

  init.process({}, [
    // Prompt for these values.
    init.prompt('name'),
    init.prompt('licenses', 'MIT'),
    init.prompt('author_name'),
  ], function(err, props) {

    props.keywords = [];

    // Files to copy (and process).
    var files = init.filesToCopy(props);

    // Add properly-named license files.
    init.addLicenseFiles(files, props.licenses);

    // Actually copy (and process) files.
    init.copyAndProcess(files, props, {noProcess: 'libs/**'});

    // Generate package.json file, used by npm and grunt.
    init.writePackageJSON('package.json', {
      name: props.name,
      version: '0.0.0',
      devDependencies: {
        "glob": "~3.2.7",
        "grunt": "~0.4.2",
        "grunt-contrib-clean": "~0.5.0",
        "grunt-contrib-coffee": "~0.8.0",
        "grunt-contrib-connect": "~0.6.0",
        "grunt-contrib-copy": "~0.5.0",
        "grunt-contrib-watch": "~0.5.3",
        "grunt-contrib-jade": "~0.9.0",
        "grunt-s3": "~0.2.0-alpha.3",
      },
    });

    // All done!
    done();
  });

};

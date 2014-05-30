var es = require('event-stream');
var gulp = require('gulp');
var gulpif = require('gulp-if');
var gutil = require('gulp-util');
var args = require('yargs').argv;
var rev = require('gulp-rev');
var serve = require('gulp-serve');
var coffee = require('gulp-coffee');
var plumber = require('gulp-plumber');
var deps = require('gulp-deps');
var stylus = require('gulp-stylus');
var filter = require('gulp-filter');
var watch = require('gulp-watch');
var gzip = require('gulp-gzip');
var amdOptimize = require('amd-optimize');
var livereload = require('gulp-livereload');
var manifest = require('gulp-manifest');
var traceur = require('gulp-traceur');
var hamlc = require('gulp-hamlc');
var uglify = require('gulp-uglify');
var clean = require('gulp-clean');

var src = 'source/**/*.*';
var dest = 'build/';
var pipe = es.pipe;

var split = function() {
  return this;
};

var log = function() {
  return es.map(function(file, cb) {
    console.log(file.cwd, file.base, file.path);
    cb(null, file);
  });
};

var err = function() {
  return plumber({
    errorHandler: function(error) {
      gutil.beep();
      console.log(error.stack);
    }
  });
};

var fext = function(pattern) {
  var streams = [].slice.call(arguments, 1);
  var fltr = filter(pattern);
  return pipe.apply(this, [fltr].concat(streams, fltr.restore()));
};

var tape = function(ext) {
  var streams = [].slice.call(arguments, 1);
  if (/,/.test(ext)) ext = '{' + ext + '}';

  return fext.apply(this, ['**/*.' + ext].concat(streams));
};

var build = function() {
  return pipe(
    tape('coffee', coffee()),
    tape('js', traceur({modules: 'amd'})),
    tape('styl', stylus({import: './source/views/app/vendor'})),
    gulp.dest(dest + 'dev'),
    log(),
    tape('js,jst', uglify({outSourceMap: true})),
    tape('css,js,jst', pipe(rev(), gzip())),
    fext('!**/*.map', manifest({timestamp: false, reemit: true})),
    gulp.dest(dest + 'prod')
  );
};

gulp.task('build', function() {
  return pipe(
    gulp.src(src),
    build()
  );
});

gulp.task('clean', function() {
  return gulp.src('build/**', {read: false})
    .pipe(clean());
});

gulp.task('watch', function() {
  return pipe(
    gulp.src(src, {read: false}),
    watch(),
    err(),
    build(),
    livereload()
  );
});

gulp.task('serve', serve({
  root: ['build/dev'],
  port: 4321
  // middleware: function(req, res) {
  // }
}));

gulp.task('default', ['watch', 'serve']);

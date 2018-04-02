export const activate = oni => {
  console.log('config activated');

  // Input
  oni.input.unbind('<c-tab>');
  oni.input.unbind('<c-pageup>');
  oni.input.unbind('<c-pagedown>');
  oni.input.unbind('<c-p>');
  oni.input.unbind('<f3>');

  // oni.input.bind('<c-enter>', () => console.log('Control+Enter was pressed'));
  // oni.input.bind('<a-c-i>', 'language.format');
  oni.input.bind('<c-p>', 'contextMenu.previous');
  oni.input.bind('<c-p>', 'menu.previous');
};

export const deactivate = oni => {
  console.log('config deactivated');
};

// Helpers
const getCygwinPath = () =>
  process.env.PATH.split(';')
    .find(path => path.includes('cygwin'))
    .split('\\')
    .reduce(
      (path, str) =>
        path.some(str => str.includes('cygwin')) ? path : path.concat(str),
      [],
    )
    .join('\\');

export const configuration = {
  'ui.colorscheme': 'nord',

  //"oni.useDefaultConfig": true,
  //"oni.bookmarks": ["~/Documents"],
  'oni.loadInitVim': (process.env.OS || '').includes('Windows')
    ? `${getCygwinPath()}\\home\\${process.env.USERNAME}\\.oni\\oni.vim`
    : `${process.env.HOME}/.oni/oni.vim`,
  'editor.fontSize': '14px',
  'editor.fontFamily': 'Source Code Pro',
  'editor.maximizeScreenOnStart': true,

  // UI customizations
  'ui.animations.enabled': true,
  'ui.fontSmoothing': 'auto',

  'statusbar.fontSize': '13px',
};

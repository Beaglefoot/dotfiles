const osIsWindows = (process.env.OS || '').includes('Windows');

export const activate = oni => {
  console.log('config activated');

  // Input
  oni.input.unbind('<c-tab>');
  oni.input.unbind('<c-pageup>');
  oni.input.unbind('<c-pagedown>');
  oni.input.unbind('<f3>');
  oni.input.unbind('<c-t>');
  oni.input.unbind('<delete>');

  // oni.input.bind('<c-enter>', () => console.log('Control+Enter was pressed'));
  // oni.input.bind('<a-c-i>', 'language.format');
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
  'ui.colorscheme': 'solarized8_light',
  'colors.background': '#EEE8D5',
  'colors.highlight.mode.normal.background': '#268BD2',
  'colors.highlight.mode.visual.background': '#D33682',
  'colors.highlight.mode.insert.background': '#2AA198',
  'colors.highlight.mode.operator.background': '#CB4B16',
  'colors.editor.hover.title.background': '#FDF6E3',

  //"oni.useDefaultConfig": true,
  //"oni.bookmarks": ["~/Documents"],
  'oni.loadInitVim': osIsWindows
    ? `${getCygwinPath()}\\home\\${process.env.USERNAME}\\.config\\oni\\oni.vim`
    : `${process.env.HOME}/.config/oni/oni.vim`,
  'oni.hideMenu': true,
  'editor.fontSize': '14px',
  'editor.fontFamily': 'Source Code Pro',
  'editor.maximizeScreenOnStart': true,

  // UI customizations
  'ui.animations.enabled': true,
  'ui.fontSmoothing': 'auto',

  'statusbar.fontSize': '13px'
};

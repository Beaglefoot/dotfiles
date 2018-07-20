declare const process: any;

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
      []
    )
    .join('\\');

export const configuration = {
  'ui.colorscheme': 'solarized8_light',
  'colors.background': '#EEE8D5',
  'colors.editor.background': '#FDF6E3',
  'colors.highlight.mode.normal.background': '#268BD2',
  'colors.highlight.mode.visual.background': '#D33682',
  'colors.highlight.mode.insert.background': '#2AA198',
  'colors.highlight.mode.operator.background': '#CB4B16',
  'colors.editor.hover.title.background': '#FDF6E3',
  'colors.menu.background': '#EEE8D5',
  'colors.menu.foreground': '#586E75',
  'colors.toolTip.background': '#FDF6E3',
  'colors.sidebar.foreground': '#657B83',
  'colors.editor.hover.contents.background': '#3F4652',
  'colors.editor.hover.contents.foreground': '#B4BEBE',

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

const repaintSurroundingContainer = ({
  icon,
  foregroundColor,
  backgroundColor
}) => {
  const container = icon.parentNode.parentNode;
  container.style.backgroundColor = backgroundColor;
  container.style.color = foregroundColor;
};

const repaintState = {
  attempts: 0,
  classesToRepaint: ['fa-bolt', 'fa-magic']
};

const intervalID = setInterval(() => {
  repaintState.classesToRepaint = repaintState.classesToRepaint.filter(
    className => {
      const icon = document.getElementsByClassName(className)[0];

      if (icon) {
        repaintSurroundingContainer({
          icon,
          backgroundColor: '#839496',
          foregroundColor: '#EEE8D5'
        });

        return false;
      }

      return true;
    }
  );

  if (++repaintState.attempts > 200 || !repaintState.classesToRepaint.length)
    clearInterval(intervalID);
}, 50);

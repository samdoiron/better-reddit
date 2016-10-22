import * as DOM from './dom';

const CONFIG = {
  classes: {
    body: {
      isScrollLocked: 'is-scroll-locked'
    }
  }
}

export function lockScroll() {
  DOM.addClass(document.body,
               CONFIG.classes.body.isScrollLocked);
}

export function unlockScroll() {
  DOM.removeClass(document.body,
                  CONFIG.classes.body.isScrollLocked);
}

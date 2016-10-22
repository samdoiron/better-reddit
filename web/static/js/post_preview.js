import {onReady} from './events';
import {lockScroll, unlockScroll} from './page';
import * as DOM from './dom';

const CONFIG = {
  selectors: {
    postPreview: '.js-post-preview',
    cover: '.js-cover'
  },

  classes: {
    postPreview: {
      isOpen: 'is-open'
    },
    cover: {
      isActive: 'is-active'
    },
    body: {
      isScrollLocked: 'is-scroll-locked'
    }
  }
}


function getPostPreview() {
  return DOM.selectOne(CONFIG.selectors.postPreview);
}

function getCover() {
  return DOM.selectOne(CONFIG.selectors.cover);
}

function showCover() {
  DOM.addClass(getCover(), CONFIG.classes.cover.isActive);
}

function hideCover() {
  DOM.removeClass(getCover(), CONFIG.classes.cover.isActive);
}

function loadPreview() {
}

function closePostPreview() {
  hideCover();
  unlockScroll();
  DOM.removeClass(getPostPreview(),
                  CONFIG.classes.postPreview.isOpen);
}

function openPostPreview() {
  showCover();
  lockScroll();
  DOM.addClass(getPostPreview(),
               CONFIG.classes.postPreview.isOpen);
}

function isPostPreview(element) {
  return element.classList.contains('.js-post-preview');
}

onReady(() => {
  document.body.addEventListener('click', e => {
    if (!isPostPreview(e.target)) {
    }
  });

  getCover().addEventListener('click', closePostPreview);

  DOM.behave('.js-open-preview', post => {
    post.on('click', e => {
      e.preventDefault();
      openPostPreview();
    });
  });
});

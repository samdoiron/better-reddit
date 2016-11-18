import {onReady} from './events';
import {lockScroll, unlockScroll} from './page';
import * as Net from './net';
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

function closePostPreview() {
  getPostPreview().innerHTML = '';
  hideCover();
  unlockScroll();
  DOM.removeClass(getPostPreview(),
                  CONFIG.classes.postPreview.isOpen);
}

function loadPreview(url) {
  Net.loadUrlIntoElement(url + '/embed', getPostPreview());
}

function openPostPreview(url) {
  loadPreview(url);
  showCover();
  lockScroll();
  DOM.addClass(getPostPreview(),
               CONFIG.classes.postPreview.isOpen);
}

function isPostPreview(element) {
  return element.classList.contains(CONFIG.classes.postPreview);
}

function isNewTabOpenAttempt(e) {
  return e.ctrlKey || e.shiftKey || e.metaKey || (e.button && e.button == 1);
}

onReady(() => {
  let cover = getCover();
  if (cover) {
    cover.on('click', closePostPreview);
  }

  DOM.behave('.js-open-preview', link => {
    link.on('click', e => {
      if (!isNewTabOpenAttempt(e)){
        e.preventDefault();
        openPostPreview(e.target.href);
      }
    });
  });
});

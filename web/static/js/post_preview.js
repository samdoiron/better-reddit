import {onReady} from './events';
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
  }
}


function getPostPreview() {
  return DOM.selectOne(CONFIG.selectors.postPreview);
}

function closePostPreview() {
  getPostPreview().innerHTML = '';
  DOM.removeClass(getPostPreview(),
                  CONFIG.classes.postPreview.isOpen);
}

function loadPreview(url) {
  Net.loadUrlIntoElement(url + '/embed', getPostPreview());
}

function openPostPreview(url) {
  loadPreview(url);
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
  document.on('click', closePostPreview);

  DOM.behave('.js-open-preview', link => {
    link.on('click', e => {
      console.log('clock');
      if (!isNewTabOpenAttempt(e)){
        e.preventDefault();
        openPostPreview(e.target.href);
      }
    });
  });
});

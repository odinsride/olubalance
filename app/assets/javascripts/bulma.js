  // Functions
  function getAll(selector) {
    return Array.prototype.slice.call(document.querySelectorAll(selector), 0);
  }

document.addEventListener('turbolinks:load', function () {
  // Modals
  var rootEl = document.documentElement;
  var $modals = getAll('.modal');
  var $modalButtons = getAll('.modal-button');
  var $modalCloses = getAll('.modal-background, .modal-close, .modal-card-head .delete, .modal-card-foot .button, .card-footer .card-modal-close');

  if ($modalButtons.length > 0) {
    $modalButtons.forEach(function ($el) {
      $el.addEventListener('click', function () {
        var target = $el.dataset.target;
        openModal(target);
      });
    });
  }

  if ($modalCloses.length > 0) {
    $modalCloses.forEach(function ($el) {
      $el.addEventListener('click', function () {
        closeModals();
      });
    });
  }

  function openModal(target) {
    var $target = document.getElementById(target);
    rootEl.classList.add('is-clipped');
    $target.classList.add('is-active');
  }

  function closeModals() {
    rootEl.classList.remove('is-clipped');
    $modals.forEach(function ($el) {
      $el.classList.remove('is-active');
    });
  }
});

document.addEventListener('keydown', function (event) {
  var e = event || window.event;
  if (e.keyCode === 27) {
    closeModals();
    closeDropdowns();
  }
});


// Dropdowns
document.addEventListener('turbolinks:load', function () {
  var $dropdowns = getAll('.dropdown:not(.is-hoverable)');

  if ($dropdowns.length > 0) {
    $dropdowns.forEach(function ($el) {
      $el.addEventListener('click', function (event) {
        event.stopPropagation();
        $el.classList.toggle('is-active');
      });
    });

    document.addEventListener('click', function (event) {
      closeDropdowns();
    });
  }

  function closeDropdowns() {
    $dropdowns.forEach(function ($el) {
      $el.classList.remove('is-active');
    });
  }
});



// navbar-burger and navbar-menu
document.addEventListener('turbolinks:load', () => {
  // Get all "navbar-burger" elements
  const $navbarBurgers = getAll('.navbar-burger');

  // Check if there are any navbar burgers
  if ($navbarBurgers.length > 0) {

    // Add a click event on each of them
    $navbarBurgers.forEach( el => {
      el.addEventListener('click', () => {

        // Get the target from the "data-target" attribute
        const target = el.dataset.target;
        const $target = document.getElementById(target);

        // Toggle the "is-active" class on both the "navbar-burger" and the "navbar-menu"
        el.classList.toggle('is-active');
        $target.classList.toggle('is-active');

      });
    });
  }

});

// bulma-toast extension

/*!
 * bulma-toast 1.5.0
 * (c) 2018-present @rfoel <rafaelfr@outlook.com>
 * Released under the MIT License.
 */
(function (a, b) {
  'object' == typeof exports && 'undefined' != typeof module ? b(exports) : 'function' == typeof define && define.amd ? define(['exports'], b) : b(a.bulmaToast = {})
})(this, function (a) {
  'use strict';

  function b() {
    g = {
      noticesTopLeft: i.createElement('div'),
      noticesTopRight: i.createElement('div'),
      noticesBottomLeft: i.createElement('div'),
      noticesBottomRight: i.createElement('div'),
      noticesTopCenter: i.createElement('div'),
      noticesBottomCenter: i.createElement('div'),
      noticesCenter: i.createElement('div')
    };
    for (let a in g.noticesTopLeft.setAttribute('style', `${'width:100%;z-index:99999;position:fixed;pointer-events:none;display:flex;flex-direction:column;padding:15px;'}left:0;top:0;text-align:left;align-items:flex-start;`), g.noticesTopRight.setAttribute('style', `${'width:100%;z-index:99999;position:fixed;pointer-events:none;display:flex;flex-direction:column;padding:15px;'}right:0;top:0;text-align:right;align-items:flex-end;`), g.noticesBottomLeft.setAttribute('style', `${'width:100%;z-index:99999;position:fixed;pointer-events:none;display:flex;flex-direction:column;padding:15px;'}left:0;bottom:0;text-align:left;align-items:flex-start;`), g.noticesBottomRight.setAttribute('style', `${'width:100%;z-index:99999;position:fixed;pointer-events:none;display:flex;flex-direction:column;padding:15px;'}right:0;bottom:0;text-align:right;align-items:flex-end;`), g.noticesTopCenter.setAttribute('style', `${'width:100%;z-index:99999;position:fixed;pointer-events:none;display:flex;flex-direction:column;padding:15px;'}top:0;left:0;right:0;text-align:center;align-items:center;`), g.noticesBottomCenter.setAttribute('style', `${'width:100%;z-index:99999;position:fixed;pointer-events:none;display:flex;flex-direction:column;padding:15px;'}bottom:0;left:0;right:0;text-align:center;align-items:center;`), g.noticesCenter.setAttribute('style', `${'width:100%;z-index:99999;position:fixed;pointer-events:none;display:flex;flex-direction:column;padding:15px;'}top:0;left:0;right:0;bottom:0;flex-flow:column;justify-content:center;align-items:center;`), g) i.body.appendChild(g[a]);
    h = {
      "top-left": g.noticesTopLeft,
      "top-right": g.noticesTopRight,
      "top-center": g.noticesTopCenter,
      "bottom-left": g.noticesBottomLeft,
      "bottom-right": g.noticesBottomRight,
      "bottom-center": g.noticesBottomCenter,
      center: g.noticesCenter
    }, f = !0
  }

  function c(a) {
    f || b();
    let c = Object.assign({}, e, a);
    const d = new j(c),
      g = h[c.position] || h[e.position];
    g.appendChild(d.element)
  }

  function d(a) {
    for (let b in g) {
      let a = g[b];
      a.parentNode.removeChild(a)
    }
    i = a, b()
  }
  const e = {
    message: 'Your message here',
    duration: 2e3,
    position: 'top-right',
    closeOnClick: !0,
    opacity: 1
  };
  let f = !1,
    g = {},
    h = {},
    i = document;
  class j {
    constructor(a) {
      this.element = i.createElement('div'), this.opacity = a.opacity, this.type = a.type, this.animate = a.animate, this.dismissible = a.dismissible, this.closeOnClick = a.closeOnClick, this.message = a.message, this.duration = a.duration, this.pauseOnHover = a.pauseOnHover;
      let b = `width:auto;pointer-events:auto;display:inline-flex;opacity:${this.opacity};`,
        c = ['notification'];
      if (this.type && c.push(this.type), this.animate && this.animate.in && (c.push(`animated ${this.animate.in}`), this.onAnimationEnd(() => this.element.classList.remove(this.animate.in))), this.element.className = c.join(' '), this.dismissible) {
        let a = i.createElement('button');
        a.className = 'delete', a.addEventListener('click', () => {
          this.destroy()
        }), this.element.insertAdjacentElement('afterbegin', a)
      } else b += 'padding: 1.25rem 1.5rem';
      this.closeOnClick && this.element.addEventListener('click', () => {
        this.destroy()
      }), this.element.setAttribute('style', b), 'string' == typeof this.message ? this.element.insertAdjacentHTML('beforeend', this.message) : this.element.appendChild(this.message);
      const d = new k(() => {
        this.destroy()
      }, this.duration);
      this.pauseOnHover && (this.element.addEventListener('mouseover', () => {
        d.pause()
      }), this.element.addEventListener('mouseout', () => {
        d.resume()
      }))
    }
    destroy() {
      this.animate && this.animate.out ? (this.element.classList.add(this.animate.out), this.onAnimationEnd(() => this.removeChild(this.element))) : this.removeChild(this.element)
    }
    removeChild(a) {
      a.parentNode && a.parentNode.removeChild(a)
    }
    onAnimationEnd(a = () => {}) {
      const b = {
        animation: 'animationend',
        OAnimation: 'oAnimationEnd',
        MozAnimation: 'mozAnimationEnd',
        WebkitAnimation: 'webkitAnimationEnd'
      };
      for (const c in b)
        if (this.element.style[c] !== void 0) {
          this.element.addEventListener(b[c], () => a());
          break
        }
    }
  }
  class k {
    constructor(a, b) {
      this.timer, this.start, this.remaining = b, this.callback = a, this.resume()
    }
    pause() {
      window.clearTimeout(this.timer), this.remaining -= new Date - this.start
    }
    resume() {
      this.start = new Date, window.clearTimeout(this.timer), this.timer = window.setTimeout(this.callback, this.remaining)
    }
  }
  a.toast = c, a.setDoc = d, Object.defineProperty(a, '__esModule', {
    value: !0
  })
});

// end bulma-toast
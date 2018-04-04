app.directive('contenteditable', ['$timeout', function($timeout) { return {
    restrict: 'A',
    require: '?ngModel',
    link: function(scope, element, attrs, ngModel) {
      // don't do anything unless this is actually bound to a model
      if (!ngModel) {
        return
      }

      // options
      var opts = {}
      angular.forEach([
        'stripBr',
        'noLineBreaks',
        'selectNonEditable',
        'moveCaretToEndOnChange',
        'stripTags'
      ], function(opt) {
        var o = attrs[opt]
        opts[opt] = o && o !== 'false'
      })

      opts.stripTags = true;
      opts.stripBr = true;
      opts.moveCaretToEndOnChange = true

      // view -> model
      element.bind('paste', function(e) {
        $timeout(function() {
          var html = element.html().replace(/<\S[^><]*>/g, '').replace(/<br>$/, '').replace(/&nbsp;/, " ")
          element.html(html)
          ngModel.$setViewValue(html)
          ngModel.$render()
        })
      })

      element.bind('input', function(e) {
        scope.$apply(function() {
          var html, html2, rerender
          html = element.html()
          rerender = false

          if (opts.noLineBreaks) {
            html2 = html.replace(/<div>/g, '').replace(/<br>/g, '').replace(/<\/div>/g, '')
            if (html2 !== html) {
              rerender = true
              html = html2
            }
          }

          ngModel.$setViewValue(html)
          if (rerender) {
            ngModel.$render()
          }
          if (html === '') {
            // the cursor disappears if the contents is empty
            // so we need to refocus
            $timeout(function(){
              element[0].blur()
              element[0].focus()
            })
          }
        })
      })

      // model -> view
      var oldRender = ngModel.$render
      ngModel.$render = function() {
        var el, el2, range, sel
        if (!!oldRender) {
          oldRender()
        }
        var html = ngModel.$viewValue || ''
        if (opts.stripTags) {
          html = html.replace(/<\S[^><]*>/g, '')
        }

        element.html(html)
        if (opts.moveCaretToEndOnChange) {
          el = element[0]
          range = document.createRange()
          sel = window.getSelection()
          if (el.childNodes.length > 0) {
            el2 = el.childNodes[el.childNodes.length - 1]
            range.setStartAfter(el2)
          } else {
            range.setStartAfter(el)
          }
          range.collapse(true)
          sel.removeAllRanges()
          sel.addRange(range)
          // opts.moveCaretToEndOnChange = false;
        }
      }
      if (opts.selectNonEditable) {
        element.bind('click', function(e) {
          var range, sel, target
          target = e.toElement
          if (target !== this && angular.element(target).attr('contenteditable') === 'false') {
            range = document.createRange()
            sel = window.getSelection()
            range.setStartBefore(target)
            range.setEndAfter(target)
            sel.removeAllRanges()
            sel.addRange(range)
          }
        })
      }
    }
  }}]);
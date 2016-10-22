export function request(method, url, callback, error) {
  let request = new XMLHttpRequest();
  request.open(method, url, true);
  request.setRequestHeader('Content-Type', 'application/x-www-form-urlencoded; charset=UTF-8');

  request.onload = () => {
    if (request.status >= 200 && request.status < 400) {
      var resp = request.responseText;
      callback(request.responseText);
    } else {
      error(false);
    }
  };

  request.onerror = function() {
    error(true);
  };


  request.send(data);
}

function redirectToUrl(currentUrl, nextUrl) {
  nextUrl = window.location.href.replace(currentUrl, nextUrl);
  window.location.href = nextUrl;
}

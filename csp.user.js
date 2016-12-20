// ==UserScript==
// @name        Upgrade Insecure Requests
// @namespace   org.wangqr.csp
// @include     https://*
// @run-at      document-start
// @version     1
// @grant       none
// ==/UserScript==

m = document.createElement('meta');
m.setAttribute('http-equiv','Content-Security-Policy');
m.setAttribute('content','upgrade-insecure-requests');
document.head.appendChild(m);

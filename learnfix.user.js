// ==UserScript==
// @name        HTTPS fix for learn.cic@THU
// @namespace   org.wangqr.thhttps
// @description Patch the broken https in learn.cic
// @include     https://learn.cic.tsinghua.edu.cn/*
// @version     1
// @grant       none
// @run-at      document-end
// ==/UserScript==
if (typeof unsafeWindow.baseUrl !== 'undefined') {
  if (unsafeWindow.baseUrl === 'http://learn.cic.tsinghua.edu.cn:80') {
    unsafeWindow.baseUrl = '';
  }
}

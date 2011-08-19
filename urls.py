# -*- coding: utf-8 -*-

from django.conf.urls.defaults import patterns, include, url

from django.contrib import admin
admin.autodiscover()

urlpatterns = patterns('',
    url(r'^$', 'django.views.generic.simple.redirect_to', {'url': '/admin/'}),
    url(r'^admin/', include(admin.site.urls)),
)


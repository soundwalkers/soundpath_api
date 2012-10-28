require File.join(Rails.root, 'lib', 'soundpath_error')

# API wrappers
require File.join(Rails.root, 'lib', 'facebook', 'facebook_band')
require File.join(Rails.root, 'lib', 'lastfm',    'lastfm_band')

# Resque Workers
require File.join(Rails.root, 'app', 'workers',   'lastfm_worker')

#Exceptions
require File.join(Rails.root, 'lib', 'exceptions')

# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.
use Mix.Config

import_config "#{Mix.Project.config()[:target]}.exs"

config :nerves,
  interface: :wlan0,
  ssid: System.get_env("NERVES_NETWORK_SSID"),
  psk: System.get_env("NERVES_NETWORK_PSK"),
  key_mgmt: System.get_env("NERVES_NETWORK_KEY_MGMT")

config :nerves_init_gadget,
  ifname: "usb0",
  address_method: :dhcpd,
  mdns_domain: "drizzle.local",
  node_name: nil,
  node_host: :mdns_domain

config :drizzle,
  location: %{latitude: System.get_env("LATITUDE"), longitude: System.get_env("LONGITUDE")},
  utc_offset: -6,
  winter_months: [:jan, :feb, :nov, :dec],
  soil_moisture_sensor: %{pin: 26, min: 0, max: 539},
  zone_pins: %{
    zone1: 7,
    zone2: 8,
    zone3: 25,
    zone4: 24,
    zone5: 23,
    zone6: 18,
    zone7: 15,
    zone8: 14
  },
  # watering times are defined as key {start_time, end_time}
  available_watering_times: %{
    morning: {500, 800},
    evening: {2100, 2300}
  },
  # schedule is defined as {zone, watering_time_key, duration_in_minutes}
  schedule: %{
    sun: [
      {:zone4, :morning, 20},
      {:zone5, :morning, 20},
      {:zone6, :morning, 20},
      {:zone7, :morning, 10}
    ],
    mon: [
      {:zone1, :morning, 20},
      {:zone3, :morning, 20}
    ],
    tue: [
      {:zone4, :morning, 20},
      {:zone5, :morning, 20},
      {:zone6, :morning, 20},
      {:zone7, :morning, 10}
    ],
    wed: [
      {:zone1, :morning, 20},
      {:zone3, :morning, 20}
    ],
    thu: [
      {:zone4, :morning, 20},
      {:zone5, :morning, 20},
      {:zone6, :morning, 20},
      {:zone7, :morning, 10}
    ],
    fri: [
      {:zone1, :morning, 20},
      {:zone3, :morning, 20},
      {:zone5, :evening, 10}
    ],
    sat: [
      {:zone7, :morning, 10},
      {:zone5, :morning, 10}
    ]
  }

config :darkskyx,
  api_key: System.get_env("DARKSKY_API_KEY"),
  defaults: [
    units: "us",
    lang: "en"
  ]

# Customize non-Elixir parts of the firmware.  See
# https://hexdocs.pm/nerves/advanced-configuration.html for details.
config :nerves, :firmware, rootfs_overlay: "rootfs_overlay"

# Use shoehorn to start the main application. See the shoehorn
# docs for separating out critical OTP applications such as those
# involved with firmware updates.
config :shoehorn,
  init: [:nerves_runtime],
  app: Mix.Project.config()[:app]

# Import target specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
# Uncomment to use target specific configurations

# import_config "#{Mix.Project.config[:target]}.exs"

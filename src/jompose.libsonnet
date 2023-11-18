local utils = import 'utils.libsonnet';

local composeFile = 'docker-compose.json';

local generateDotEnv(attrs) = utils.cleanTextBlock(|||
	COMPOSE_FILE=%(file)s
	COMPOSE_PROJECT_NAME=%(name)s
|||) % attrs;

local generateService(name, svc) = {
	hostname: '_' + name,
	restart: 'unless-stopped',
	tty: true,
	stdin_open: true,
} + svc;

local generateNetwork(_, net) = {
	driver: 'bridge',
	enable_ipv6: true,
	ipam: {
		driver: 'default',
		config: std.map(function(subnet) {
			subnet: subnet,
		}, net.subnets),
	},
	driver_opts: {
		'com.docker.network.bridge.name': net.name,
	},
};

function(attrs) {
	[composeFile]: std.manifestJsonEx({
		version: '3.8',
		services: std.mapWithKey(generateService, attrs.services),
		networks: std.mapWithKey(generateNetwork, attrs.networks),
		volumes: std.get(attrs, 'volumes', {}),
		configs: std.get(attrs, 'configs', {}),
		secrets: std.get(attrs, 'secrets', {}),
	}, '\t'),
	'.env': generateDotEnv({
		file: composeFile,
		name: attrs.name,
	}),
}

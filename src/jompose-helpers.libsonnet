local utils = import 'utils.libsonnet';

{
	buildArgs(attrs):: utils.foldMap(function(acc, key, value) acc + [key + '=' + value], attrs, []),
}

{ writeShellApplication, substituteAll, jsonnet, docker-client, jomposeStd }:
writeShellApplication {
	name = "jompose";

	runtimeInputs = [ jsonnet docker-client ];

	text = __readFile (substituteAll {
		src = ./jompose.sh;
		inherit jomposeStd;
	});
}

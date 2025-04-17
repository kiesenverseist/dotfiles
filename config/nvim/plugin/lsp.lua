vim.lsp.enable {
	"lua_ls",
	"basedpyright",
	"nixd",
	"ruff",
	"yamlls",
	"ruby_lsp",
}

vim.lsp.config("nixd", {
	settings = {
		nixd = {
			nixpkgs = { expr = "import <nixpkgs> { }" },
			formatting = { command = { "alejandra" } },
			options = {
				nixos = {
					expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.graphite.options',
				},
				home_manager = {
					expr =
					'(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."kiesen@graphite".options',
				},
			},
		},
	},
})

vim.lsp.config("yamlls", {
	settings = {
		-- https://github.com/redhat-developer/vscode-redhat-telemetry#how-to-disable-telemetry-reporting
		redhat = { telemetry = { enabled = false } },
		yaml = {
			schemas = {
				["https://raw.githubusercontent.com/instrumenta/kubernetes-json-schema/master/v1.18.0-standalone-strict/all.json"] =
				"*.k8s.yaml",
				["http://json.schemastore.org/github-workflow"] = ".github/workflows/*",
				["http://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
				["http://json.schemastore.org/ansible-stable-2.9"] = "roles/tasks/*.{yml,yaml}",
				["http://json.schemastore.org/prettierrc"] = ".prettierrc.{yml,yaml}",
				["http://json.schemastore.org/kustomization"] = "kustomization.{yml,yaml}",
				["http://json.schemastore.org/ansible-playbook"] = "*play*.{yml,yaml}",
				["http://json.schemastore.org/chart"] = "Chart.{yml,yaml}",
				["https://json.schemastore.org/dependabot-v2"] = ".github/dependabot.{yml,yaml}",
				["https://json.schemastore.org/gitlab-ci"] = "*gitlab-ci*.{yml,yaml}",
				["https://bitbucket.org/atlassianlabs/intellij-bitbucket-references-plugin/raw/master/src/main/resources/schemas/bitbucket-pipelines.schema.json"] =
				"*bitbucket-pipelines*.{yml,yaml}",
				["https://raw.githubusercontent.com/OAI/OpenAPI-Specification/main/schemas/v3.1/schema.json"] =
				"*api*.{yml,yaml}",
				["https://raw.githubusercontent.com/compose-spec/compose-spec/master/schema/compose-spec.json"] =
				"*docker-compose*.{yml,yaml}",
				["https://raw.githubusercontent.com/argoproj/argo-workflows/master/api/jsonschema/schema.json"] =
				"*flow*.{yml,yaml}",
			},
		},
	},
})

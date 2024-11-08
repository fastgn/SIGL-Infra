#!/bin/bash

cd ../
# Exécuter Terraform apply et rediriger la sortie
terraform apply -auto-approve | tee output.md

# Formater les outputs en Markdown
echo -e "\n# Outputs\n" >> output.md
terraform output -json | jq -r 'to_entries | .[] | "## \(.key)\n\n\(.value)\n"' >> output.md

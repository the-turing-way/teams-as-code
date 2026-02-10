import json
import sys
import typer
from jsonschema import validate, ValidationError
from ruamel.yaml import YAML

# safe loader, no object construction
yaml = YAML(typ="safe")

app = typer.Typer(
    no_args_is_help=True,
    rich_markup_mode="markdown",
    pretty_exceptions_show_locals=False,
)


def load_yaml(file_path: str) -> dict:
    with open(file_path) as f:
        yaml_data = yaml.load(f)
    return yaml_data


def validate_yaml_against_schema(yaml_data: str, schema_data: str) -> None:
    try:
        validate(instance=yaml_data, schema=schema_data)
        print("✅ YAML is valid according to the schema.")
    except ValidationError as e:
        print("❌ YAML validation failed:")
        print(e.message)
        sys.exit(1)


@app.command()
def main(
    yaml_path: str = typer.Argument(help="Path to YAML file to validate"),
    schema_path: str = typer.Argument(help="Path to schema file for validation"),
) -> None:
    # Load files
    yaml_data = load_yaml(yaml_path)
    schema_data = load_yaml(schema_path)

    # Check validity
    validate_yaml_against_schema(yaml_data, schema_data)


if __name__ == "__main__":
    app()

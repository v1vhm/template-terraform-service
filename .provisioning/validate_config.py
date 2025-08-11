#!/usr/bin/env python3
"""Validate repository-config.yml against schema."""
import json
import sys
from pathlib import Path

import yaml
from jsonschema import ValidationError, validate

ROOT = Path(__file__).resolve().parent
CONFIG_FILE = ROOT / "repository-config.yml"
SCHEMA_FILE = ROOT / "repository-config-schema.json"


def main() -> int:
    try:
        config_data = yaml.safe_load(CONFIG_FILE.read_text())
    except Exception as exc:  # noqa: BLE001
        print(f"Failed to parse {CONFIG_FILE}: {exc}", file=sys.stderr)
        return 1

    try:
        schema = json.loads(SCHEMA_FILE.read_text())
    except Exception as exc:  # noqa: BLE001
        print(f"Failed to load schema {SCHEMA_FILE}: {exc}", file=sys.stderr)
        return 1

    try:
        validate(instance=config_data, schema=schema)
    except ValidationError as exc:
        print(f"Validation error: {exc.message}", file=sys.stderr)
        return 1

    print("repository-config.yml is valid")
    return 0


if __name__ == "__main__":
    raise SystemExit(main())

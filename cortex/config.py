#!/usr/bin/env python3
# -*- coding: utf8 -*-

import sys
import yaml
import os.path
from textwrap import wrap
import prettytable
from collections import defaultdict


ARG_TEMPLATE = """{{{{- if default .Values.cortex.{2} .Values.{1}.{2} }}}}
- -{0}={{{{ default .Values.cortex.{2} .Values.{1}.{2} }}}}
{{{{- end }}}}"""


def get_values_config(service, data):
    if service == "cortex":
        to_process = [param for params in data.values() for param in params]
    else:
        to_process = data[service]
    printed = set()
    for param in sorted(to_process, key=lambda x: x["argument"]):
        if param["value"] in printed: continue
        for line in wrap(param["comment"], width=79):
            print("# {}".format(line))
        print("# {} cli: -{}".format(service, param["argument"]))
        print("#{}:".format(param["value"]))
        print()
        printed.add(param["value"])


def get_template_config(service, data):
    if service in data:
        svc = service.replace("-", "_")
        for param in sorted(data[service], key=lambda x: x["argument"]):
            argument = ARG_TEMPLATE.format(param["argument"], svc, param["value"])
            print(argument)
    else:
        print("There is no such service")


def get_params_readme(service, params):
    print("### {} Arguments".format(service.capitalize()))
    printed = set()
    table = prettytable.PrettyTable()
    table.field_names=["Parameter","Description","Default"]
    table.align["Parameter"] = "l"
    table.align["Description"] = "l"
    table.align["Default"] = "l"
    table.junction_char = "|"
    for param in sorted(params, key=lambda x: x["argument"]):
        if param["value"] in printed: continue
        value = "`{}.{}`".format(service, param["value"])
        default = "`NA`"
        table.add_row([value, param["comment"], default])
        printed.add(param["value"])
    print(table.get_string())


def get_readme(data):
    global_params = [param for params in data.values() for param in params]
    get_params_readme("cortex", global_params)
    for service, params in data.items():
        get_params_readme(service.replace("-", "_"), params)


def main():
    with open("cortex-arguments.yaml") as f:
        data = yaml.load(f)
    services = set()
    for service, parameters in data.items():
        services.add(service)
        for parameter in parameters:
            argument = parameter["argument"]
            parameter["value"] = "{}".format(argument.replace(".", "_").replace("-", "_"))

    if len(sys.argv) < 2:
        name = os.path.basename(sys.argv[0])
        print("Usage: {} <service_name>".format(name,))
        print(" service_name:\t\t\tName of service to print options, allowed values:")
        print("    cortex\t\t\t\tPrint values for cortex global configuration")
        print()
        print("    <cortex_service>\tName of cortex's service, allowed:\n    \t\t\t\t\t{}".format(",".join(sorted(services))))
        sys.exit(1)

    command = sys.argv[1]
    if command == "services":
        print("\n".join(sorted(services)))
    if command == "cortex":
        get_values_config(command, data)
        sys.exit(0)
    if command in services:
        get_values_config(command, data)
        get_template_config(command, data)
        sys.exit(0)
    if command == "readme":
        get_readme(data)
        sys.exit(0)


if __name__ == "__main__":
    main()
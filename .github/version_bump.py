import subprocess
import sys
import re
from enum import Enum, EnumMeta


class MyEnumMeta(EnumMeta):
    def __contains__(self, other):
        try:
            self(other)
        except ValueError:
            return False
        return True


class UpgradeType(Enum, metaclass=MyEnumMeta):
    NONE = 'none'
    PATCH = 'patch'
    MINOR = 'minor'
    MAJOR = 'major'


class ProductType(Enum, metaclass=MyEnumMeta):
    NONE = 'none'
    THA_APP = 'tha-app'
    WEBAPP = 'webapp'
    INFRA = 'infra'
    UNIVERSAL_CHART = 'universal_chart'


def get_current_version(chart_path: str) -> str:
    with open(f"{chart_path}/Chart.yaml") as f:
        for line in f:
            if line.startswith("version:"):
                return line.split(":")[1].strip()
    return None


def build_new_version(base_version: str, rc_suffix: str) -> str:
    return f"{base_version}-rc.{rc_suffix}"


def main(argv):
    chart = ProductType.NONE
    upgrade = UpgradeType.NONE
    rc_suffix = None

    for arg in argv:
        if arg in ProductType:
            chart = ProductType(arg)
        elif arg in UpgradeType:
            upgrade = UpgradeType(arg)
        elif arg.startswith("rc="):
            rc_suffix = arg.split("=", 1)[1]

    if chart == ProductType.NONE:
        print("❌ Chart type not defined.")
        exit(1)

    chart_path = f"./charts/{chart.value}"

    if upgrade == UpgradeType.NONE:
        print("No upgrade type detected. Skipping version bump.")
        exit(0)

    print(f"📦 Chart: {chart.value}")
    print(f"⬆️ Upgrade type: {upgrade.value}")

    if rc_suffix:
        # First do a dry bump to compute new version
        result = subprocess.run(
            f"bump2version --dry-run --list {upgrade.value}",
            shell=True,
            cwd=chart_path,
            capture_output=True,
            check=True
        )
        output = result.stdout.decode()
        new_version_match = re.search(r"new_version=(\S+)", output)
        if not new_version_match:
            print("❌ Failed to extract new version from bump2version output.")
            exit(1)
        base_version = new_version_match.group(1)
        final_version = build_new_version(base_version, rc_suffix)

        print(f"📌 Bumping to: {final_version} (RC)")

        subprocess.run(
            f"bump2version --new-version {final_version} {upgrade.value}",
            shell=True,
            cwd=chart_path,
            check=True
        )
    else:
        print(f"📌 Bumping to next {upgrade.value}")
        subprocess.run(
            f"bump2version {upgrade.value}",
            shell=True,
            cwd=chart_path,
            check=True
        )


if __name__ == "__main__":
    main(sys.argv[1:])

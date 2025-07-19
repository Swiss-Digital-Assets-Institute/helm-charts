import subprocess
import sys
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


def main(argv):
    chart = ProductType.NONE
    upgrade = UpgradeType.NONE

    for label in argv:
        if label in ProductType:
            chart = ProductType(label)
        elif label in UpgradeType:
            upgrade = UpgradeType(label)

    if upgrade == UpgradeType.NONE or chart == ProductType.NONE:
        print("No need for a version bump detected")
        exit(0)

    print(
        f"Bumping version of '{chart.value}' to next '{upgrade.value}' value.")

    try:
        subprocess.run(
            f"bump2version {upgrade.value}",
            shell=True,
            cwd=f"./charts/{chart.value}",
            capture_output=True,
            check=True
        )
    except subprocess.CalledProcessError as e:
        print("❌ Could not execute version bump.")
        print(f"Return code: {e.returncode}")
        print("STDERR:")
        print(e.stderr.decode())
        print("STDOUT:")
        print(e.stdout.decode())
        exit(1)


if __name__ == "__main__":
    main(sys.argv[1:])

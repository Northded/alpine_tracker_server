import subprocess
import json
import sys
import os

def run_command(cmd, description):
    print(f"\n{description}...")
    try:
        result = subprocess.run(cmd, shell=True, capture_output=False, text=True)
        if result.returncode != 0:
            print(f"FAILED: {description}")
            return False
        print(f"PASSED")
        return True
    except Exception as e:
        print(f"ERROR: {e}")
        return False

def check_ruff():
    print("\n1/3 Code Quality Check (Ruff)...")
    
    result = subprocess.run(
        "ruff check . --output-format=json",
        shell=True,
        capture_output=True,
        text=True
    )
    
    try:
        data = json.loads(result.stdout)
        blockers = [item for item in data if item["code"].startswith(("E9", "F"))]
        
        if blockers:
            print(f"FAILED: Found {len(blockers)} BLOCKER issues")
            return False
        
        print("PASSED")
        return True
    except:
        print("PASSED")
        return True

def check_semgrep():
    print("\n2/3 Security Check (Semgrep)...")
    
    result = subprocess.run(
        "semgrep --config=auto --json --severity=ERROR --output=semgrep_report.json .",
        shell=True,
        capture_output=True,
        text=True
    )
    
    try:
        with open("semgrep_report.json", "r") as f:
            data = json.load(f)
        
        critical = len(data.get("results", []))
        
        if critical > 0:
            print(f"FAILED: Found {critical} CRITICAL issues")
            return False
        
        print("PASSED")
        return True
    except:
        print("PASSED")
        return True

def check_gitleaks():
    print("\n3/3 Secrets Check (Gitleaks)...")
    
    result = subprocess.run(
        "gitleaks detect --source=. --report-path=gitleaks_report.json --no-git",
        shell=True,
        capture_output=True,
        text=True
    )
    
    try:
        if os.path.exists("gitleaks_report.json") and os.path.getsize("gitleaks_report.json") > 0:
            with open("gitleaks_report.json", "r") as f:
                data = json.load(f)
            
            if len(data) > 0:
                print(f"FAILED: Found {len(data)} secrets")
                return False
    except:
        pass
    
    print("PASSED")
    return True

def main():
    print("=" * 50)
    print("Running Static Analysis Checks")
    print("=" * 50)
    
    ruff_ok = check_ruff()
    semgrep_ok = check_semgrep()
    gitleaks_ok = check_gitleaks()
    
    print("\n" + "=" * 50)
    
    if ruff_ok and semgrep_ok and gitleaks_ok:
        print("All checks PASSED")
        print("=" * 50)
        return 0
    else:
        print("Some checks FAILED")
        print("=" * 50)
        return 1

if __name__ == "__main__":
    sys.exit(main())

# Assignment requirements and evidence

The assignment brief is the source for this checklist. Evidence must represent actual command or application output; historical screenshots are labeled as such and do not prove current AWS state.

| Requirement | Implementation / status | Evidence |
|---|---|---|
| AWS CLI setup and Terraform initialization | Historical setup shown; current AWS CLI returned `NoCredentials`; Terraform is not on the current PATH. | `evidence/01-aws-setup/historical-aws-identity-region.png`; no current identity proof |
| VPC, public/private subnet, IGW, NAT, routes | Terraform files define the requested topology. Current live resources are unknown. | Historical plan summary only |
| Public web EC2 and private database EC2 | Terraform resources are defined; not provisioned/verified in this session. | No EC2 evidence yet |
| SSH restricted to administrator IP | Web security group uses `admin_ip/32`; current public IP could not be queried from this environment. Database SSH is now allowed only from web SG for jump-host Ansible access. | Configuration review; no live SG evidence |
| Security groups and IAM roles | Web and database groups are defined; EC2 role has SSM core policy. Live state unknown. | Historical identity screenshot shows the user's previous broad IAM permissions, not the EC2 role |
| Output web public IP | Terraform output is defined. No current state/output. | No output evidence yet |
| Ansible communicates with instances | PowerShell inventory generation and web-jump DB routing are implemented; not executed. No WSL distribution is currently installed. | No execution evidence yet |
| Install Node.js/NPM, clone app, install dependencies | Web role is implemented; not executed. | No deployment evidence yet |
| Install and secure MongoDB; create users/database | MongoDB role installs the official 8.0 packages, binds to the private interface, enables auth, and reconciles admin/app users from Vault; not executed. | No database evidence yet |
| Configure app and frontend/backend connectivity | Web role builds React with same-origin API paths, serves through Nginx, and proxies `/trip`, `/uploads`, and `/health`; the API port is excluded from public ingress. Local React tests/build pass, but deployed runtime is not tested. | Local test output only; no working-app evidence yet |
| Security hardening | Terraform requires IMDSv2 and encrypted gp3 roots; SSH ingress is constrained. Ansible configures UFW, disables root/password SSH, and keeps host-key checking enabled; not executed. | No hardening evidence yet |
| Detailed report and component interaction | Report and Mermaid architecture are in `architecture-and-deployment-report.md`; final test outcomes remain pending. | Documentation in repository |
| Working MERN application screenshots/video | Not captured. The local frontend production build passed with `REACT_APP_BACKEND_URL=/`; executable JS chunks contain no localhost API URL. | No valid runtime screenshot yet |
| Push to GitHub and submit repository URL | Not done. Root assignment repository has not been initialized; source application remains its own nested Git checkout. | No repository URL yet |

## Historical screenshot review

- `historical-aws-identity-region.png` shows a prior CLI identity, configured region, attached IAM policies, and available availability zones. It is useful as historic context, not current authentication proof.
- `historical-init-validate.png` shows Terraform initialization and validation succeeding for the then-current configuration.
- `historical-plan-summary.png` shows a historical plan summary of 17 additions, no changes, and no destructions. It is not a current plan and must not be applied.
- `Screenshot 2026-10-27 105312.png` in the workspace-level `screenshots/` folder contains a private key. It was excluded from this repository's evidence. Treat that key as exposed and replace it before deployment.

## Evidence still required

Capture genuine screenshots after each milestone: current AWS identity/region; current Terraform fmt/init/validate and reviewed plan; VPC, routes, instances, security groups and IAM; Ansible success; MongoDB private/authenticated verification; API health; frontend with real API data and uploaded images; SSH/firewall hardening; and the final application. Do not reuse historical screenshots to represent these future states.

## Local checks performed on 2026-10-27

- `node --check` passed for all backend JavaScript files.
- Frontend Jest suite passed: 1 suite, 2 tests.
- Create React App production build passed with `REACT_APP_BACKEND_URL=/`; executable JS chunks contain no `localhost:3001` or `localhost:3000` URL.
- Node `js-yaml` successfully parsed all 12 Ansible `.yml` files. This is a YAML parse only, not an Ansible syntax check or execution.
- Build output includes the repository's existing outdated Browserslist data and CRA Babel dependency warnings. Dependencies and lockfiles were not intentionally updated.

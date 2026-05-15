# Phase 1: Host Optimization & Storage Migration
Before writing any code, secure your C: drive space and allocate hardware resources effectively.

**Task 1:** Open Docker Desktop settings and change the "Virtual Disk" or "Disk image location" to a dedicated folder on your workspace drive, such as W:\DockerData.

**Task 2:** Export your current WSL Ubuntu instance using PowerShell: wsl --export Ubuntu W:\WSL\ubuntu-export.tar.

**Task 3:** Unregister the default C: drive instance: wsl --unregister Ubuntu.

**Task 4:** Import the instance directly to your workspace drive: wsl --import Ubuntu W:\WSL\Ubuntu W:\WSL\ubuntu-export.tar.

**Task 5:** Create a .wslconfig file in your Windows user profile (C:\Users\<YourUsername>\.wslconfig) to allocate 16GB of RAM and 8 CPU threads, ensuring the subsystem has plenty of power without starving Windows.

**Task 6:** Completely shut down WSL (wsl --shutdown) and restart it to apply the memory and CPU limits.

# Phase 2: Linux Subsystem Foundation
Prepare the internal Linux environment for high-speed development.

**Task 1:** Boot into your newly migrated Ubuntu instance.

**Task 2:** Generate SSH keys within the Linux terminal and attach them to your GitHub account for seamless authentication.

**Task 3:** Create a project directory strictly within the native Linux filesystem (e.g., ~/projects/ticket-api).

Crucial Warning: Do not create this project folder in /mnt/w/... or /mnt/c/.... Crossing the Windows/Linux file system boundary will cripple your read/write speeds. Keep the code living natively inside the Linux virtual disk.

# Phase 3: Custom Docker Infrastructure
Write the infrastructure as code to orchestrate your services without relying on pre-built abstractions.

**Task 1:** Create a custom Dockerfile. Base it on a lightweight image (like Debian or Alpine), install PHP 8.3/8.4, Composer, and the specific extensions required for Laravel Octane (such as Swoole or FrankenPHP).

**Task 2:** Ensure the Dockerfile creates a non-root user (e.g., www-data) and sets the correct permissions for the working directory to avoid root ownership conflicts on your generated files.

**Task 3:** Create a docker-compose.yml file at the root of your project.

**Task 4:** Define the app service to build from your custom Dockerfile and expose the Octane port.

**Task 5:** Define the web service using an official Nginx image. Write an Nginx configuration file that acts as a reverse proxy, forwarding port 80 traffic to the app container.

**Task 6:** Define db (PostgreSQL/MySQL) and redis services. Configure named volumes for both so your database records and cached data survive container teardowns.

# Phase 4: Laravel 12 & Octane Bootstrapping
Initialize the framework and configure it for the containerized network.

**Task 1:** Spin up a temporary, interactive PHP container mapped to your Linux directory to run composer create-project laravel/laravel . and scaffold the Laravel 12 files.

**Task 2:** Install Laravel Octane via Composer and select your preferred high-performance server (Swoole or FrankenPHP).

**Task 3:** Update the ENTRYPOINT or CMD in your custom Dockerfile to automatically execute php artisan octane:start --host=0.0.0.0 when the container boots.

**Task 4:** Modify the .env file to use the exact Docker service names for connections (e.g., DB_HOST=db, REDIS_HOST=redis) instead of 127.0.0.1.

# Phase 5: Automated Testing & CI/CD
Solidify the workflow with an automated pipeline.

**Task 1:** Initialize Git within the Linux project folder and push the initial commit to your repository.

**Task 2:** Create a .github/workflows/docker-ci.yml file.

**Task 3:** Write the pipeline steps to check out the code, use docker compose up -d to build and boot the entire stack within the GitHub Actions runner, execute php artisan migrate, and run the Pest or PHPUnit test suite inside the app container.

# The Final Test (Definition of Done)
Your training exercise is completely successful when you can check off these four metrics:

**Immaculate Boot:** Running docker compose up -d --build successfully compiles your custom image and boots Nginx, Postgres, Redis, and the Octane server without a single error.

**State Persistence:** You can run docker compose down, turn off your PC, boot everything back up the next day, and your local database records are still there.

**High-Concurrency Validation:** Hitting your local Nginx proxy with a load testing tool (like Apache Bench or wrk) proves that Octane is handling the traffic, yielding significantly higher requests-per-second than a standard PHP-FPM setup.

**Green Pipeline:** Your GitHub Actions tab shows a passing workflow, proving your containerized architecture is completely portable.
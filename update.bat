@echo off
setlocal enabledelayedexpansion

for /d %%D in (sites\*) do (
    if not exist "%%D\" (
        echo WARNING: %%D is not a directory, skipping.
    ) else (
        if not exist "%%D\.env" (
            echo WARNING: .env file not found in %%D, skipping.
        ) else (
            set "project_name=%%~nxD"
            echo ==============================
            echo Starting docker compose for project: !project_name!
            echo Directory: %%D
            echo Env file: %%D\.env
            echo ------------------------------

            docker compose -p !project_name! --env-file "%%D\.env" -f template\docker-compose.yml up -d --build
            if errorlevel 1 (
                echo ERROR: Docker compose failed for !project_name!
            ) else (
                echo SUCCESS: Docker compose finished for !project_name!
            )

            echo ==============================
            echo.
        )
    )
)

endlocal

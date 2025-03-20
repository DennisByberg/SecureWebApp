# SecureWebApp Tutorial 🛡️🔐

## Förutsättningar

Jag har precis avslutat utvecklingen av min webbapplikation skriven i .NET. Webbapplikationen är nu redo att driftsättas så att alla mina fans där ute på internet kan surfa till den och få den där wow-upplevelsen som de vet att de alltid får när jag släpper ny programkod - vilket jag gör ganska ofta.

Lite tråkigt är det emellertid att hackergruppen "Cloud Just Means Rain" ständigt ger sig på min sajt. Men med mitt senaste arbete kring säkerhet, så kommer de ingen vart.

## Uppgift

1. Jag ska designa en säker driftsmiljö för min webbapplikation.
2. Jag ska basera lösningen på virtuella servrar på Azure.
3. Jag ska beskriva vad de olika komponenterna i min design har för uppgift och syfte.
4. Jag ska beskriva vilka åtgärder jag vidtagit för ökad säkerhet.
5. Jag ska redogöra för vilka molntjänster jag utnyttjat.
6. Jag ska göra en tydlig avgränsning i min design och beskriva sedan steg för steg hur jag provisionerar driftsmiljön samt driftsätter min applikation.
7. Jag ska vara tydlig med vilka verktyg jag använder.
8. Jag ska beskriva hur jag använder IaC och automation - om jag gör det.
9. Jag ska förklara hur säkerheten påverkar min provisionering och driftsättning.

## Git & CI/CD

### Steg 1: Web-App redo för versionshantering.

Skapandet av våran web-app är nu redo för att versionshanteras och vi har den fungerande lokalt.

![alt text]({3E35C3E5-1196-4418-A017-271538963CC9}.png)

Vi ska nu gå igenom några steg för att få upp den på vårat Github-repo där vi kommer att versionshantera våran app.

Vi börjar med skapa en `.gitignore` fil för att inte lägga upp allt som vi inte behöver på `GitHub`

```bash
dotnet new gitignore
```

Vårat nästa steg blir att initialisera vårat git repo och göra vår första commit.

```bash
git init
```

```bash
git add .
```

```bash
git commit -m "Initial Commit"
```

Push to Github: Use VSCode’s integrated git functionality to connect your local repository to Github and push your initial commit. Follow the prompts in VSCode to authenticate and specify your repository details on Github.

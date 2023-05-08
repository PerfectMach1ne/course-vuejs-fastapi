from typing import List

from fastapi import FastAPI
from pydantic import BaseModel
from starlette.middleware.cors import CORSMiddleware

app = FastAPI()

app.add_middleware(
  CORSMiddleware,
  allow_origins=["*"],
  allow_credentials=True,
  allow_methods=["*"],
  allow_headers=["*"],
)

class TeamOut(BaseModel):
    name: str
    layer: str
    wins: int = 0
    losses: int = 0


class Team(TeamOut):
    id: int


teams = [
    Team(id=0, name="Solstice", layer="White Void", wins=7, losses=2),
    Team(id=1, name="Equinox", layer="Edge of the Dream", wins=2, losses=13),
    Team(id=2, name="Dystopia", layer="n/a", wins=998, losses=2),  # these two losses are as catastrophic as they can gets (deserved :3)
    Team(id=3, name="lesbianism", layer="*thanos voice* Every one.", wins=1000000, losses=0)
]


@app.get("/")
async def root():
    return {"message": "Helooo wooorlldd!!!"}


@app.get("/teams", response_model=List[TeamOut])
async def get_teams():
    return teams


@app.post("/team/{name}")
async def score_team(name: str, win: bool = True):
    for team in teams:
        if team.name == name:
            if win:
                team.wins += 1
            else:
                team.losses += 1
            return team

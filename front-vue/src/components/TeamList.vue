<template>
  <div>
    <ul v-for="team in teams" :key="team.name">
      <TeamRow v-bind:team="team" @reload="reload()"/>      
    </ul>
  </div>
</template>

<script lang="ts">
import { Options, Vue } from 'vue-class-component';
import { api } from '@/utils';
import { Team } from '@/models/team';
import TeamRow from '@/components/TeamRow.vue';

async function loadTeams(): Promise<Team[]> {
  const resp = await api.get('teams')
  return resp.data as Team[]
}

@Options({
  components: {
    TeamRow,
  }
})
export default class TeamList extends Vue {
  teams: Team[] = [/*{
    name: "lesbianism/2.0",
    layer: "The Eigth Layer",
    wins: 2000057,
    losses: -1
  }*/]

  public mounted(): void {
    this.reload();
  }
  public reload(): void {
    loadTeams().then(
      (teams) => this.teams = teams,
      (error) => console.log(error)
    )
  }
}
</script>

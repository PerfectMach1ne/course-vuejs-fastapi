<template>
  <li>
    <strong>{{ team.name }}</strong> -- <small>{{ team.layer }}</small> - <small>{{ team.wins }}</small> / <small>{{ team.losses }}</small>
    <button @click="addScore(true)">Add W</button>
    <button @click="addScore(false)">Add L<Label></Label></button>
  </li>
</template>

<script lang="ts">
import { PropType } from 'vue'
import { Options, Vue } from 'vue-class-component';
import { Team } from '@/models/team';
import { api } from '@/utils'

@Options({
  props: {
    team: { type: Object as PropType<Team> }
  },
  emits: ['reload']
})
export default class TeamRow extends Vue {
  team!: Team

  public addScore(win: boolean): void {
    // if (win) {
    //   this.team.wins++;
    // } else {
    //   this.team.losses++;
    // }
    api.post('team/' + this.team.name, null, { params: {win} /*shorthand 4 {'win': win}*/ }).then(
      () => this.$emit('reload')
    )
  }
}
</script>
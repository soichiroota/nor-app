<template>
  <div v-if="errors.length" class="mt-15">
    <v-alert type="error">
      {{ errors.join("。") }}
    </v-alert>
  </div>
</template>

<script>
export default {
  props: {
    errors: {
      type: Array,
      default: () => {}
    },
    showLabel: {
      type: Boolean,
      default: true
    }
  }
};
</script>

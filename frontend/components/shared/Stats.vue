<template>
  <div>
    <div v-if="user">
      <div class="stats">
        <a :href="`users/${user.id}/showFollowing`">
          <strong id="following" class="stat">
            {{ user.following_count }}
          </strong>
          following
        </a>
        <a :href="`users/${user.id}/showFollowers`">
          <strong id="followers" class="stat">
            {{ user.followers_count }}
          </strong>
          followers
        </a>
      </div>
    </div>
  </div>
</template>

<script>
export default {
  props: {
    user: Object
  }
};
</script>

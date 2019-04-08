<template>
    <span><p>{{url}}</p></span>
</template>

<script>
export default {
    props: {
        url: {
            type: String,
            required: true
        }
    }
}
</script>

<style scoped>
    img {
        height: 1em;
        width: 1em;
    }

    p {
        display: inline;
         color: #888888;
    }
</style>

import React, { Component  } from "react";
import PropTypes from "prop-types";
import StoryMedia from "./StoryMedia";
import InfiniteScroll from 'react-infinite-scroller';

class StoryList extends Component {
  static propTypes = {
    stories: PropTypes.array
  };

  constructor(props) {
    super(props)

    this.state = {
      stories: [],
      hasMoreStories: true,
      nextHref: null
    }
  }

  renderStory() {
    var items = []
    this.state.stories.map((story, i) => {
      items.push(
        <li
          className={`story storypoint${story.point && story.point.id}`}
          onClick={_ => this.props.onStoryClick([story.point.lng, story.point.lat])}
          key={i}
        >
          <div className="speakers">
            <img src={story.speaker.picture_url} alt={story.speaker.name} title={story.speaker.name}/>
          </div>
          <div className="container">
            <h6 className="title">{story.title}</h6>
            <p>{story.desc}</p>
            <p>{story.type_of_place}</p>
            {story.media &&
              story.media.map(file => <StoryMedia file={file} />)}
          </div>
        </li>
      )
    })
    return items
  }

  loadStories = page => {
    // loadMore
    fetch(
      `/stories.json?page_num=${page}`, {
        method: "GET",
        headers: {
          "Content-Type": "application/json"
        }
      }
    )
    .then(response => response.json())
    .then(
      json => {
        var stories = this.state.stories;
        json.stories.map(story => stories.push(story))

        if (json.nextHref) {
          this.setState({
            stories: stories,
            nextHref: json.nextHref
          });
        } else {
          this.setState({
            hasMoreStories: false
          });
        }
      }
    )
  }

  render() {
    return (
      <div className="stories">
        <InfiniteScroll
            pageStart={0}
            loadMore={this.loadStories}
            hasMore={this.state.hasMoreStories}
            loader={<div className="loader" key={0}>Loading ...</div>}
            useWindow={false}
        >
          <ul>
            {this.renderStory()}
          </ul>
        </InfiniteScroll>
      </div>
    );
  }
}

export default StoryList;

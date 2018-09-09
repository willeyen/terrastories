import React, { PureComponent } from "react";
import PropTypes from "prop-types";
import StoryMedia from "./StoryMedia";

class StoryList extends PureComponent {
  static propTypes = {
    stories: PropTypes.array
  };

  render() {
    return (
      <div className="stories">
        <ul>
          {this.props.stories.map(story => {
            return (
              <li
                className={`story storypoint${story.point && story.point.id}`}
              >
                <div className="speakers">
                  <img src={story.speaker.picture_url} alt={story.speaker.name} title={story.speaker.name}/>
                </div>
                <div className="container">
                  <strong className="title">{story.title}</strong>
                  <div className="description">{story.desc}</div>
                  {story.media &&
                    story.media.map(file => <StoryMedia file={file} />)}
                </div>
              </li>
            );
          })}
        </ul>
      </div>
    );
  }
}

export default StoryList;

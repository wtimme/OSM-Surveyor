module Fastlane
  module Actions
    class GetHighestBuildNumberFromGitTagsAction < Action
      def self.run(params)
        output = `git ls-remote --tags`
        UI.user_error!("Unable to get the tags from the repository") unless $?.exitstatus == 0
        getHighestTag(output)
      end

      def self.getHighestTag tags
        tags.split().map { |s| s[/\d+\.\d+.\d+-(\d+)$/,1].to_i }.max.to_i
      end

      def self.description
        "Retrieves the highest build number from the repository's tags"
      end

      def self.details
        "This action is useful when releasing from different branches that have not been merged back yet. It requires the tags to have a format like '1.2.3-4'."
      end

      def self.return_type
        :int
      end

      def self.return_value
        "The highest build number in the repository"
      end

      def self.is_supported?(platform)
        true
      end
    end
  end
end

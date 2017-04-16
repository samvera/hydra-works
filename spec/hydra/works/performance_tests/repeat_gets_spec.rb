require 'spec_helper'

describe 'repeat_gets' do

  context "with large number of generic files" do
    let(:generic_works) { {   10 => Hydra::Works::GenericWork.create,
                              50 => Hydra::Works::GenericWork.create,
                             100 => Hydra::Works::GenericWork.create
                            # 1000 => Hydra::Works::GenericWork.create
                          } }
    before do
      puts( "============================================" )
      puts( " Creating and appending generic files" )
      puts( "============================================" )
      puts( "gfile count   time (s)   time/gfile")
      puts( "-----------   --------   ----------")
      format = "%8d      %8.3f   %7.3f\n"

      generic_works.each_pair do |generic_file_count,generic_work|
        st = Time.now.to_f
        generic_file_count.times do
          Hydra::Works::AddGenericFileToGenericWork.call( generic_work, Hydra::Works::GenericFile.create )
        end
        t = Time.now.to_f - st
        printf( format,10,t,t/generic_file_count )
      end
    end

    describe 'time separate get approaches for various counts of generic files in a work' do
      xit 'should perform consistently across each approach' do
        format = "%-20s   %8.5f   %10.5f\n"
        printf("\n\n")

        generic_works.each_pair do |generic_file_count,generic_work|
          puts
          puts( "============================================" )
          puts( " Getting #{generic_file_count} generic files 1 time" )
          puts( "============================================" )
          puts( "    get approach       time (s)   time/gfile (s)")
          puts( "--------------------   --------   --------------")

          st = Time.now.to_f
          generic_work.generic_files
          t = Time.now.to_f - st
          printf( format,".generic_files",t,t/generic_file_count )

          st = Time.now.to_f
          Hydra::Works::GetGenericFilesFromGenericWork.call( generic_work )
          t = Time.now.to_f - st
          printf( format,"get service",t,t/generic_file_count )

          st = Time.now.to_f
          expect( Hydra::Works::GetGenericFilesFromGenericWork.call( generic_work ).size ).to eq generic_file_count
          t = Time.now.to_f - st
          printf( format,"expect + get service",t,t/generic_file_count )
        end
      end
    end
  end

  context "with large number of gets" do
    describe 'time repeatedly getting generic files from the same generic work' do
      let(:generic_work10)   { Hydra::Works::GenericWork.create }
      # let(:repeat_counts)    { [10,50,100,1000]}
      let(:repeat_counts)    { [10,50,100]}

      before do
        10.times do
          Hydra::Works::AddGenericFileToGenericWork.call( generic_work10, Hydra::Works::GenericFile.create )
        end
      end

      xit 'should perform consistently across each approach' do
        format = "%-20s   %8.5f   %10.5f\n"
        printf("\n\n")

        repeat_counts.each do |repeat_count|
          puts
          puts( "============================================" )
          puts( " Getting 10 generic_files #{repeat_count} times" )
          puts( "============================================" )
          puts( "    get approach       time (s)   time/get (s)")
          puts( "--------------------   --------   ------------")

          st = Time.now.to_f
          repeat_count.times do
            generic_work10.generic_files
          end
          t = Time.now.to_f - st
          printf( format,".generic_files",t,t/repeat_count )

          st = Time.now.to_f
          repeat_count.times do
            Hydra::Works::GetGenericFilesFromGenericWork.call( generic_work10 )
          end
          t = Time.now.to_f - st
          printf( format,"get service",t,t/repeat_count )

          st = Time.now.to_f
          repeat_count.times do
            expect( Hydra::Works::GetGenericFilesFromGenericWork.call( generic_work10 ).size ).to eq 10
          end
          t = Time.now.to_f - st
          printf( format,"expect + get service",t,t/repeat_count )
        end
      end
    end
  end
end

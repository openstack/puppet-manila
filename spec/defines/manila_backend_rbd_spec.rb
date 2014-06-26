require 'spec_helper'

describe 'manila::backend::rbd' do

  let(:title) {'rbd-ssd'}

  let :req_params do
    {
      :share_backend_name              => 'rbd-ssd',
      :rbd_pool                         => 'shares',
      :glance_api_version               => '2',
      :rbd_user                         => 'test',
      :rbd_secret_uuid                  => '0123456789',
      :rbd_ceph_conf                    => '/foo/boo/zoo/ceph.conf',
      :rbd_flatten_share_from_snapshot => true,
      :share_tmp_dir                   => '/foo/tmp',
      :rbd_max_clone_depth              => '0'
    }
  end

  it { should contain_class('manila::params') }

  let :params do
    req_params
  end

  let :facts do
    {:osfamily => 'Debian'}
  end

  describe 'rbd backend share driver' do
    it 'configure rbd share driver' do
      should contain_manila_config("#{req_params[:share_backend_name]}/share_backend_name").with_value(req_params[:share_backend_name])
      should contain_manila_config("#{req_params[:share_backend_name]}/share_driver").with_value('manila.share.drivers.rbd.RBDDriver')
      should contain_manila_config("#{req_params[:share_backend_name]}/rbd_ceph_conf").with_value(req_params[:rbd_ceph_conf])
      should contain_manila_config("#{req_params[:share_backend_name]}/rbd_flatten_share_from_snapshot").with_value(req_params[:rbd_flatten_share_from_snapshot])
      should contain_manila_config("#{req_params[:share_backend_name]}/share_tmp_dir").with_value(req_params[:share_tmp_dir])
      should contain_manila_config("#{req_params[:share_backend_name]}/rbd_max_clone_depth").with_value(req_params[:rbd_max_clone_depth])
      should contain_manila_config("#{req_params[:share_backend_name]}/rbd_pool").with_value(req_params[:rbd_pool])
      should contain_manila_config("#{req_params[:share_backend_name]}/rbd_user").with_value(req_params[:rbd_user])
      should contain_manila_config("#{req_params[:share_backend_name]}/rbd_secret_uuid").with_value(req_params[:rbd_secret_uuid])
      should contain_file('/etc/init/manila-share.override').with(:ensure => 'present')
      should contain_file_line('set initscript env').with(
        :line    => /env CEPH_ARGS=\"--id test\"/,
        :path    => '/etc/init/manila-share.override',
        :notify  => 'Service[manila-share]')
    end

    context 'with rbd_secret_uuid disabled' do
      let(:params) { req_params.merge!({:rbd_secret_uuid => false}) }
      it { should contain_manila_config("#{req_params[:share_backend_name]}/rbd_secret_uuid").with_ensure('absent') }
    end

    context 'with share_tmp_dir disabled' do
      let(:params) { req_params.merge!({:share_tmp_dir => false}) }
      it { should contain_manila_config("#{req_params[:share_backend_name]}/share_tmp_dir").with_ensure('absent') }
    end

    context 'with another RBD backend' do
      let :pre_condition do
        "manila::backend::rbd { 'ceph2':
           rbd_pool => 'shares2',
           rbd_user => 'test'
         }"
      end
      it { should contain_manila_config("#{req_params[:share_backend_name]}/share_driver").with_value('manila.share.drivers.rbd.RBDDriver') }
      it { should contain_manila_config("#{req_params[:share_backend_name]}/rbd_pool").with_value(req_params[:rbd_pool]) }
      it { should contain_manila_config("#{req_params[:share_backend_name]}/rbd_user").with_value(req_params[:rbd_user]) }
      it { should contain_manila_config("ceph2/share_driver").with_value('manila.share.drivers.rbd.RBDDriver') }
      it { should contain_manila_config("ceph2/rbd_pool").with_value('shares2') }
      it { should contain_manila_config("ceph2/rbd_user").with_value('test') }
    end
  end

  describe 'with RedHat' do
    let :facts do
        { :osfamily => 'RedHat' }
    end

    let :params do
      req_params
    end

    it 'should ensure that the manila-share sysconfig file is present' do
      should contain_file('/etc/sysconfig/openstack-manila-share').with(
        :ensure => 'present'
      )
    end

    it 'should configure RedHat init override' do
      should contain_file_line('set initscript env').with(
        :line    => /export CEPH_ARGS=\"--id test\"/,
        :path    => '/etc/sysconfig/openstack-manila-share',
        :notify  => 'Service[manila-share]')
    end
  end

end

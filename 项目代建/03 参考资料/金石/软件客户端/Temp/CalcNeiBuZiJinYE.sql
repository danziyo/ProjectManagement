Create PROCEDURE CalcNeiBuZiJinYE
  @XMPathkey Varchar(100),
  @fsrq1 datetime,
  @fsrq2 datetime,
  @nbhr Float output,
  @wlsk Float output,
  @byjjr Float output,
  @byjhh Float output,
  @grhh Float output,
  @gcjr Float output,
  @gchr Float output,
  @nbhc Float output,
  @byjjc Float output,
  @byjhc Float output,
  @grjc Float output,
  @gcjc Float output,
  @gchc Float output,
  @wlfk Float output,
  @sfyggz Float output,
  @bqjy Float output 
AS
BEGIN
  Declare @sql Varchar(1000)
  Declare @sqldate Varchar(1000) 
  Set @sqldate=''
  IF IsNULL(@fsrq1,'')<>'' 
  Begin
    Set @sqldate=@sqldate+' And �������� >='''+cast(@fsrq1 as varchar(80))+''''
  End
  IF IsNULL(@fsrq2,'')<>'' 
  Begin
    Set @sqldate=@sqldate+' And �������� <='''+cast(@fsrq2 as varchar(80))+''''
  End

  --�ڲ����� nbhr
  Set @sql='Declare cur1 Cursor Global For select sum(������) from �ʽ𻮲�����ϸ�� where ����=0 And CharIndex('''+@XMPathkey+''',HRXMPathkey)>0 ' 
  Set @Sql=@Sql+@sqldate 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @nbhr
  Close cur1
  deallocate cur1 
  Set @nbhr=ISNULL(@nbhr,0)

  --�����տ� @wlsk 
  Set @sql='Declare cur1 Cursor Global For select SUM(���) from �ո�����ϸ�� where ��������=''�տ'' And ����=0 And CharIndex('''+@XMPathkey+''',XMPathkey)>0 ' 
  Set @Sql=@Sql+@sqldate 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @wlsk
  Close cur1         
  deallocate cur1 
  Set @wlsk=ISNULL(@wlsk,0)
 
  Set @byjjr=0
  Set @byjhh=0
--  --���ý����
--  Set @sql='Declare cur1 Cursor Global For select SUM(���) from Ա����� where ���=''���'' And ����=0 And CharIndex('''+@XMPathkey+''',BYJXMPathkey)>0  ' 
--  Set @Sql=@Sql+@sqldate 
--  Exec(@Sql)
--  Open cur1
--  Fetch Next From cur1 into @byjjr
--  Close cur1
--  deallocate cur1 
--  Set @byjjr=ISNULL(@byjjr,0) 
--
--  --���ý𻹻�
--  Set @sql='Declare cur1 Cursor Global For select SUM(���) from Ա����� where ���=''����'' And ����=0 And CharIndex('''+@XMPathkey+''',XMPathkey)>0  ' 
--  Set @Sql=@Sql+@sqldate 
--  Exec(@Sql)
--  Open cur1
--  Fetch Next From cur1 into @byjhh
--  Close cur1
--  deallocate cur1 
--  Set @byjhh=ISNULL(@byjhh,0) 

  --���˻���
  Set @sql='Declare cur1 Cursor Global For select SUM(���) from Ա����� where ���=''����'' And ����=0 And CharIndex('''+@XMPathkey+''',XMPathkey)>0  ' 
  Set @Sql=@Sql+@sqldate  --+' And ((���ý���Ŀ���� Is NULL) or (���ý���Ŀ����='''')) '
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @grhh
  Close cur1
  deallocate cur1 
  Set @grhh=ISNULL(@grhh,0) 

  --���̽���
  Set @sql='Declare cur1 Cursor Global For select SUM(���) from ���̽軹� where ����=0 And ��������=''���̽�'' And ���=''����'' And CharIndex('''+@XMPathkey+''',XMPathkey)>0 '
  Set @Sql=@Sql+@sqldate 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @gcjr
  Close cur1
  deallocate cur1 
  Set @gcjr=ISNULL(@gcjr,0)


  --���̻���
  Set @sql='Declare cur1 Cursor Global For select SUM(���) from ���̽軹� where ����=0 And ��������=''���̻��'' And ���=''����'' And CharIndex('''+@XMPathkey+''',XMPathkey)>0 '
  Set @Sql=@Sql+@sqldate 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @gchr
  Close cur1
  deallocate cur1 
  Set @gchr=ISNULL(@gchr,0)

  --�ڲ����� 
  Set @sql='Declare cur1 Cursor Global For select sum(�������) from �ʽ𻮲������˱� where ����=0 And CharIndex('''+@XMPathkey+''',HCXMPathKey)>0 '
  Set @Sql=@Sql+@sqldate 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @nbhc
  Close cur1
  deallocate cur1 
  Set @nbhc=ISNULL(@nbhc,0)

  Set @byjjc=0
  Set @byjhc=0
--  --���ý���
--  Set @sql='Declare cur1 Cursor Global For select SUM(���) from Ա����� where ���=''���'' And ����=0  And CharIndex('''+@XMPathkey+''',XMPathkey)>0 ' 
--  Set @Sql=@Sql+@sqldate 
--  Exec(@Sql)
--  Open cur1
--  Fetch Next From cur1 into @byjjc
--  Close cur1
--  deallocate cur1 
--  Set @byjjc=ISNULL(@byjjc,0)
--
--  --���ý𻹳�
--  Set @sql='Declare cur1 Cursor Global For select SUM(���) from Ա����� where ���=''����'' And ����=0  And CharIndex('''+@XMPathkey+''',BYJXMPathkey)>0 ' 
--  Set @Sql=@Sql+@sqldate 
--  Exec(@Sql)
--  Open cur1
--  Fetch Next From cur1 into @byjhc
--  Close cur1
--  deallocate cur1 
--  Set @byjhc=ISNULL(@byjhc,0)


  --���˽��
  Set @sql='Declare cur1 Cursor Global For select SUM(���) from Ա����� where ���=''���'' And ����=0  And CharIndex('''+@XMPathkey+''',XMPathkey)>0 ' 
  Set @Sql=@Sql+@sqldate   --' And ( (���ý���Ŀ���� Is NULL) or (���ý���Ŀ����='''')) '
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @grjc
  Close cur1
  deallocate cur1 
  Set @grjc=ISNULL(@grjc,0)

  --���̽��
  Set @sql='Declare cur1 Cursor Global For select SUM(���) from ���̽軹� where ����=0 And ��������=''���̽�'' And ���=''���'' And CharIndex('''+@XMPathkey+''',XMPathkey)>0 '
  Set @Sql=@Sql+@sqldate 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @gcjc
  Close cur1
  deallocate cur1 
  Set @gcjc=ISNULL(@gcjc,0)

  --���̻���
  Set @sql='Declare cur1 Cursor Global For select SUM(���) from ���̽軹� where ����=0 And ��������=''���̻��'' And ���=''����'' And CharIndex('''+@XMPathkey+''',XMPathkey)>0 '
  Set @Sql=@Sql+@sqldate 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @gchc
  Close cur1
  deallocate cur1 
  Set @gchc=ISNULL(@gchc,0)

  --��������  
  Set @sql='Declare cur1 Cursor Global For select SUM(�������) from �ֽ�������ˮ�˱� where  ����=0 And CharIndex('''+@XMPathkey+''',XMPathkey)>0 '
  Set @sql=@sql+' And ��������<>''���̽�'' And ��������<>''���̻��'' And ��������<>''Ա����'' And ��������<>''Ա�����'' And ��������<>''�ֽ������'' And ��������<>''���е�����'' And ��������<>''���д�ȡ�'' And ��������<>''����Ԥ֧��'' And ��������<>''Ա��Ԥ֧��'' And ��������<>''���ʷ��ŵ�'' '
  Set @Sql=@Sql+@sqldate 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @wlfk
  Close cur1
  deallocate cur1
  Set @wlfk=ISNULL(@wlfk,0)

  --ʵ��Ա������  
  Set @sql='Declare cur1 Cursor Global For select SUM(�������) from �ֽ�������ˮ�˱� where  ����=0 And CharIndex('''+@XMPathkey+''',XMPathkey)>0 '
  Set @sql=@sql+' And ��������=''����Ԥ֧��'' And ��������=''Ա��Ԥ֧��'' And ��������=''���ʷ��ŵ�'' '
  Set @Sql=@Sql+@sqldate 
  Exec(@Sql)
  Open cur1
  Fetch Next From cur1 into @sfyggz
  Close cur1
  deallocate cur1
  Set @sfyggz=ISNULL(@sfyggz,0)

  Set @bqjy=0
  Set @bqjy=@nbhr+@wlsk+@byjhh+@byjjr+@grhh+@gcjr+@gchr-@nbhc-@byjjc-@byjhh-@grjc-@gcjc-@gchc-@wlfk-@sfyggz
END

 